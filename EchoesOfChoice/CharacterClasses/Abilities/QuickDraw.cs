using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class QuickDraw : Ability
    {
        public QuickDraw()
        {
            Name = "Quick Draw";
            FlavorText = "Steady hands and sharp reflexes. You draw faster than they can blink.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}
