using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class FireWyrmling : BaseFighter
    {
        public FireWyrmling(int level = 6)
        {
            Level = level;
            Health = Stat(108, 119, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(15, 19, 0, 0, 6);
            PhysicalDefense = Stat(15, 19, 0, 0, 6);
            MagicAttack = Stat(27, 32, 0, 0, 6);
            MagicDefense = Stat(20, 24, 0, 0, 6);
            Speed = Stat(28, 33, 0, 0, 6);
            Abilities = new List<Ability>() { new DragonBreath(), new TailStrike(), new Roar() };
            CharacterType = "FireWyrmling";
            Mana = Stat(25, 29, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 19;
            CritDamage = 2;
            DodgeChance = 10;
        }

        public FireWyrmling(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new FireWyrmling(this);
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
