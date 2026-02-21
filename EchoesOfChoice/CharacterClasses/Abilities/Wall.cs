using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Wall : Ability
    {
        public Wall()
        {
            Name = "Wall";
            FlavorText = "Raise a barrier to block incoming attacks. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
            TargetAll = true;
        }
    }
}
