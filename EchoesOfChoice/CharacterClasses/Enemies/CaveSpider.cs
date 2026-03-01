using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class CaveSpider : BaseFighter
    {
        public CaveSpider(int level = 16)
        {
            Level = level;
            Health = Stat(260, 290, 7, 10, 16);
            MaxHealth = Health;
            PhysicalAttack = Stat(40, 48, 3, 5, 16);
            PhysicalDefense = Stat(26, 32, 2, 3, 16);
            MagicAttack = Stat(14, 18, 1, 2, 16);
            MagicDefense = Stat(22, 28, 1, 3, 16);
            Speed = Stat(34, 40, 3, 4, 16);
            Abilities = new List<Ability>() { new VenomousBite(), new Web(), new PoisonCloud() };
            CharacterType = "Cave Spider";
            Mana = Stat(20, 26, 2, 4, 16);
            MaxMana = Mana;
            CritChance = 24;
            CritDamage = 4;
            DodgeChance = 22;
        }

        public CaveSpider(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new CaveSpider(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(0, 2);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
