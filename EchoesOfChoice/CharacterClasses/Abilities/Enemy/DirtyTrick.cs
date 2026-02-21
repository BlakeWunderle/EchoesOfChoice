using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class DirtyTrick : Ability
    {
        public DirtyTrick()
        {
            Name = "Dirty Trick";
            FlavorText = "A weighted net tangles the enemy's legs, slowing them to a crawl.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
