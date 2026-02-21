using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Machinist : BaseFighter
    {
        public Machinist(int level = 6)
        {
            Level = level;
            Health = Stat(105, 115, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(29, 33, 0, 0, 6);
            PhysicalDefense = Stat(26, 31, 0, 0, 6);
            MagicAttack = Stat(23, 27, 0, 0, 6);
            MagicDefense = Stat(21, 26, 0, 0, 6);
            Speed = Stat(20, 24, 0, 0, 6);
            Abilities = new List<Ability>() { new SeismicCharge(), new Reinforce(), new Dismantle() };
            CharacterType = "Machinist";
            Mana = Stat(21, 26, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Machinist(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Machinist(this);
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
