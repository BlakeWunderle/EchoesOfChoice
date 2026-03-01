using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Harlequin : BaseFighter
    {
        public Harlequin(int level = 6)
        {
            Level = level;
            Health = Stat(104, 116, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(22, 26, 0, 0, 6);
            PhysicalDefense = Stat(19, 23, 0, 0, 6);
            MagicAttack = Stat(35, 39, 0, 0, 6);
            MagicDefense = Stat(22, 26, 0, 0, 6);
            Speed = Stat(31, 36, 0, 0, 6);
            Abilities = new List<Ability>() { new PantomimeWall(), new PropDrop(), new MimeTrap() };
            CharacterType = "Harlequin";
            Mana = Stat(33, 37, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 20;
            CritDamage = 2;
            DodgeChance = 28;
        }

        public Harlequin(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Harlequin(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(0, 1);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(0, 1);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 1);
            PhysicalDefense += random.Next(0, 1);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(0, 1);
            Speed += random.Next(0, 1);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
